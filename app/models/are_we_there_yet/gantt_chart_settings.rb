# TODO move to models 
java_import 'org.eclipse.nebula.widgets.ganttchart.ISettings'
java_import 'org.eclipse.nebula.widgets.ganttchart.AbstractSettings'

class AreWeThereYet
  class GanttChartSettings < AbstractSettings
    # TODO expose as preferences
#     def getInitialZoomLevel
#       ISettings.ZOOM_DAY_NORMAL
#     end
  end
end
