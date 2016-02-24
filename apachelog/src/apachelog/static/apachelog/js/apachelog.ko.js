
var ApachelogViewModel = function() {
  self.availableStreamingTime = ko.observableArray(['10초', '30초', '1분', '5분', '10분', '30분', '1시간']);
  self.chosenStreamingTime = ko.observableArray(['10초']); 

  self.selectableStreamingTime = ko.computed(function() {
    var _times = ko.utils.arrayMap(self.availableStreamingTime(), function (time) {
      return time;
    });
		
		$.post("/apachelog/view/fetch_selected_time_option", {
		}, function (data) {
			chosenStreamingTime.push(data.value);
		}).fail(function (xhr, textStatus, errorThrown) {
			$(document).trigger("error", "fetch select option data failed")
		});
    return _times;
  },self);
	
	self.changeStreamingTime = function(time) {
		chosenStreamingTime.push(time);
		
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
  
	
	self.availableAlertCount = ko.observableArray(['100', '500', '1,000', '5,000', '10,000', '50,000', '100,000']);
	self.chosenAlertCount = ko.observableArray(['100']);

	self.selectableAlertCount = ko.computed(function() {
    var _alert_count = ko.utils.arrayMap(self.availableAlertCount(), function (count) {
      return count;
    });
		
		$.post("/apachelog/view/fetch_selected_alert_option", {
		}, function (data) {
			chosenAlertCount.push(data.value);
		}).fail(function (xhr, textStatus, errorThrown) {
			$(document).trigger("error", "fetch select option data failed")
		});
    return _alert_count;
  },self);
	
	self.changeAlertCount = function(count) {
		chosenAlertCount.push(count);
		
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


