require 'json'

reports = ErrorReport.last(1000); 0

tempHash = []

reports.each do |report|
  unless report.project.bit_params == "" or report.project.bit_params == "null"
    bit_params = JSON.parse(report.project.bit_params)
    job_settings = JSON.parse(report.project.job_settings)

    bitWidth = 0
    feedrate = 0
    depthPerPass = 0
    profileStepOver = 0

    bitWidth = bit_params["bit"]["width"] || 0
    feedrate = job_settings["feedRate"] || 0
    depthPerPass = job_settings["depthPerPass"] || 0
    profileStepOver = job_settings["profileStepOver"] || 0

    # 4 params
    tempHash.push([
      bitWidth,
      feedrate,
      depthPerPass,
      profileStepOver,
    ])
  end
end

File.open("/tmp/carve_error_report_data3.json","w") do |f|
  f.write(tempHash.to_json)
end
