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

from django.conf.urls import patterns, url

urlpatterns = patterns('apachelog',
    url(r'^$', 'views.index'),
    url(r'^view/fetch_selected_time_option', 'views.fetch_selected_time_option', name='fetch_selected_time_option'),
	url(r'^view/fetch_selected_alert_option', 'views.fetch_selected_alert_option', name='fetch_selected_alert_option'),
    url(r'^view/update_sel_time', 'views.update_sel_time', name='update_sel_time'),
    url(r'^view/update_sel_alert', 'views.update_sel_alert', name='update_sel_alert'),
    url(r'^view/fetch_alert$', 'views.fetch_alert', name='alert'),
    url(r'^view/fetch_timeline$', 'views.fetch_timeline', name='timeline'),

)
