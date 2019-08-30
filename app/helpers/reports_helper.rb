module ReportsHelper

  def report_image_src(report, style = :thumb)
    if report.image.present?
      report.image_url(style)
    else
      ""
    end
  end
  
end
