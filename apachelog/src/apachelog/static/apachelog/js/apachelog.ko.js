
var SelectBoxMap = function(key, value){
    this.key = key;
    this.value = value;
}

var ApachelogViewModel = function() {
	self.availableStreamingTime = ko.observableArray([
        new SelectBoxMap('10초', 10),
        new SelectBoxMap('30초', 30),
        new SelectBoxMap('1분', 60),
        new SelectBoxMap('10분', 600),
        new SelectBoxMap('15분', 900),
        new SelectBoxMap('30분', 1800),
        new SelectBoxMap('1시간', 3600)
    ]);

    self.chosenStreamingTime = ko.observableArray([10]);

    self.selectableStreamingTime = ko.computed(function() {
        var _times = ko.utils.arrayMap(self.availableStreamingTime(), function (time) {
          return time;
        });

		$.post("/apachelog/view/fetch_selected_time_option", {
		}, function (data) {
            //console.log(self.valueToObject(data.value));

			chosenStreamingTime.push(Number(data.value));
		}).fail(function (xhr, textStatus, errorThrown) {
			$(document).trigger("error", "fetch select option data failed")
		});
    return _times;
  },self);
	
	self.changeStreamingTime = function(time) {
        chosenStreamingTime.push(Number(time));
		$.post("/apachelog/view/update_sel_time", {
			'time': ko.mapping.toJSON(time)
		}, function (data) {
			if (data.status == 0) {
				//alert('000000');	
			} else {
				//alert('111111');
			}
		}).fail(function (xhr, textStatus, errorThrown) {
			$(document).trigger("error", xhr.responseText);
		});
	}
  
	
	self.availableAlertCount = ko.observableArray([
        new SelectBoxMap('100', 100),
        new SelectBoxMap('500', 500),
        new SelectBoxMap('1000', 1000),
        new SelectBoxMap('2,600', 2600),
        new SelectBoxMap('5,000', 5000),
        new SelectBoxMap('10,000', 10000),
        new SelectBoxMap('50,000', 50000),
        new SelectBoxMap('100,000', 100000)
    ]);
	self.chosenAlertCount = ko.observableArray([100]);

	self.selectableAlertCount = ko.computed(function() {
    var _alert_count = ko.utils.arrayMap(self.availableAlertCount(), function (count) {
      return count;
    });
		
		$.post("/apachelog/view/fetch_selected_alert_option", {
		}, function (data) {
			chosenAlertCount.push(Number(data.value));
		}).fail(function (xhr, textStatus, errorThrown) {
			$(document).trigger("error", "fetch select option data failed")
		});
    return _alert_count;
  },self);
	
	self.changeAlertCount = function(count) {
		chosenAlertCount.push(Number(count));
		
		$.post("/apachelog/view/update_sel_alert", {
			'alert': ko.mapping.toJSON(count)
		}, function (data) {
			if (data.status == 0) {
				//alert('000000');	
			} else {
				//alert('111111');
			}
		}).fail(function (xhr, textStatus, errorThrown) {
			$(document).trigger("error", xhr.responseText);
		});
	}
}


