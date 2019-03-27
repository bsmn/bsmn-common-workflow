class: Workflow
label: synapse-bsmn-common-workflow
id: synapse-bsmn-common-workflow
cwlVersion: v1.0

inputs:
  mate1-ids:
    type: File
  mate2-ids:
    type: File
  prefix:
    type: File
  synapse_config:
    type: File
  specimenId:
    type: string

outputs:
  quants:
    type: File
    # outputSource: run-bwa-mem/output
    outputSource: [[download-mate1-files/filepath], [download-mate2-files/filepath]]

requirements:
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

steps:
  get-mate1-files:
    run: steps/out-to-array-tool.cwl
    in:
      datafile: mate1-ids
    out: [anyarray]
  download-mate1-files:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
    scatter: synapseid
    in:
      synapseid: get-mate1-files/anyarray
      synapse_config: synapse_config
    out: [filepath]
  get-mate2-files:
    run: steps/out-to-array-tool.cwl
    in:
      datafile: mate2-ids
    out: [anyarray]
  download-mate2-files:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
    scatter: synapseid
    in:
      synapseid: get-mate2-files/anyarray
      synapse_config: synapse_config
    out: [filepath]
  # run-bwa-mem:
  #   run: steps/bwa-mem-tool.cwl
  #   in:
  #      input1:
  #        source: download-mate1-files/filepath
  #      input2:
  #        source: download-mate2-files/filepath
  #      prefix: prefix
  #      output_name: specimenId
  #   out:
  #      [output]
