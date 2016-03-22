
<%!
def is_selected(section, matcher):
  if section == matcher:
    return "active"
  else:
    return ""
%>

<%def name="menubar(section='')">
  <div class="navbar navbar-inverse navbar-fixed-top nokids">
    <div class="navbar-inner">
      <div class="container-fluid">
        <div class="nav-collapse">
          <ul class="nav">
            <li class="currentApp">
              <a href="/single_analysis">
                <img src="${ static('single_analysis/art/icon_single_analysis_48.png') }" class="app-icon" />
                Single Analysis
              </a>
             </li>
             <li class="${is_selected(section, 'alert')}"><a href="#">경보</a></li>
             <li class="${is_selected(section, 'config')}"><a href="#">설정</a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</%def>
