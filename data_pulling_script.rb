require 'json'

reports = ErrorReport.last(1000); 0

BITS = {
  "INVENTABLES_BLUE_BIT" => 1,
  "INVENTABLES_BLACK_BIT" => 2,
  "INVENTABLES_WHITE_BIT" => 3,
  "INVENTABLES_GRAY_BIT" => 4
}

tempHash = []

reports.each do |report|
  unless report.project.bit_params == "" or report.project.bit_params == "null"
    bit_params = JSON.parse(report.project.bit_params)
    material_params = JSON.parse(report.project.material)
    job_settings = JSON.parse(report.project.job_settings)

    bitId = 0
    bitWidth = 0
    bitUnit = 0
    detailId = 0
    detailWidth = 0
    detailUnit = 0
    material = 0
    feedrate = 0
    depthPerPass = 0
    profileStepOver = 0

    bitId = BITS[bit_params["bit"]["id"]] || 0
    bitWidth = bit_params["bit"]["width"] || 0
    # bitUnit = bit_params["bit"]["unit"] || 0
    detailId = BITS[bit_params["detailBit"]["id"]] || 0
    detailWidth = bit_params["detailBit"]["width"] || 0
    # detailUnit = bit_params["detailBit"]["unit"] || 0
    # material = material_params["name"] || 0
    feedrate = job_settings["feedRate"] || 0
    depthPerPass = job_settings["depthPerPass"] || 0
    profileStepOver = job_settings["profileStepOver"] || 0


    # 10 params
    tempHash.push([
      bitId,
      bitWidth,
      # bitUnit,
      detailId,
      detailWidth,
      # detailUnit,
      # material,
      feedrate,
      depthPerPass,
      profileStepOver,
      0
    ])
  end
end

File.open("/tmp/carve_error_report_data2.json","w") do |f|
  f.write(tempHash.to_json)
end

