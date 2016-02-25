# -*- coding: utf-8 -*-
#!/usr/bin/env python
# Licensed to Cloudera, Inc. under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Cloudera, Inc. licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import sys, json
from desktop.lib.django_util import render, JsonResponse
import datetime, operator

from apachelog.models import SelectedOption
from kafka.consumer.group import KafkaConsumer

OPS=dict(add=operator.add, subtract=operator.sub, multiply=operator.mul, divide=operator.truediv)
OP_STRING=dict(add="+", subtract="-", multiply="*", divide="/")

def index(request):
  return render('index.mako', request, dict())

def fetch_selected_option(name):
  result = {'status': -1, 'value' : '', 'message': 'Error'}
  if name == 'time':
    defaultVal = '10초'
  elif name == 'alert':
    defaultVal = '100';

  try:
	  time = SelectedOption.objects.get(sel_name=name)
  except SelectedOption.DoesNotExist:
    time = None
  
  if(time):
    result['value'] = time.sel_val
  else:
    SelectedOption.objects.create(sel_name=name, sel_val=defaultVal)
    result['value'] = defaultVal
  
  result['status'] = 0
  result['message'] = 'seccess'
  
  return result


def fetch_selected_time_option(request):
  return JsonResponse(fetch_selected_option('time'))


def fetch_selected_alert_option(request):
  return JsonResponse(fetch_selected_option('alert'))

def update_sel_data(request, name):
  result = {'status': -1, 'message': 'Error'}
  
  try:
    time = json.loads(request.POST[name])
    SelectedOption.objects.filter(sel_name=name).update(sel_val=time)
  except:
    print "Error occurred: ", sys.exc_info()
    result['message'] = sys.exc_info()
    return result;

  result['status'] = 0
  result['message'] = 'secceeded'
  return result;

def update_sel_time(request):
  return JsonResponse(update_sel_data(request, 'time'))

def update_sel_alert(request):
  return JsonResponse(update_sel_data(request, 'alert'));

def fetch_timeline(request):
  consumer = KafkaConsumer(
          'ApacheLogAlert',
          bootstrap_servers='en1:9092,en2:9092,en3:9092',
          enable_auto_commit=True,
          auto_offset_reset='earliest'
  )

  test = consumer.poll(5000)
  i = 0
  temp = {}
  for topic in test:
    cc = test.get(topic)
    for msg in cc:
      print msg
      x = msg.key.split(' ')[0]
      y = msg.value.split(',')[2]
      key = msg.value.split(',')[1]

      if key in temp:
        temp[key].append({'x': int(x), 'y': int(y)})
      else:
        temp[key] = []
        temp[key].append({'x': int(x), 'y': int(y)})
  result = []
  for key in temp:
    result.append({'name': key, 'data': temp.get(key)})

  for key in result:
    key['data'] = sorted(key['data'], key=lambda a: a['x'])

  consumer.close()
  return render('fetch_timeline.mako', request, dict(data=result))

def fetch_alert(request):
  consumer = KafkaConsumer(
          bootstrap_servers='en1:9092,en2:9092,en3:9092',
          auto_offset_reset='earliest'
  )
  consumer.subscribe(['ApacheLogAlert'])

  time = int(request.GET.get('time', '0'));
  test = consumer.poll(10000)
  result = []
  for aa in test:
    cc = test.get(aa)
    for msg in cc:
      print msg

      try:
        int(msg.value) + 2
        int(msg.key) + 2
      except:
        continue

      if int(msg.key) <= time or int(msg.value) <= 0:
        continue
      t = datetime.datetime.fromtimestamp(int(msg.key) / 1e3).strftime('%Y-%m-%d %H:%M:%S')

      c = msg.value
      tmp = {t: c}
      result.append(tmp)
  consumer.close()
  return render('fetch_alert.mako', request, dict(data=result))