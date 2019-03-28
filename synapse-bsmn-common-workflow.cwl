class: Workflow
label: synapse-bsmn-common-workflow
id: synapse-bsmn-common-workflow
cwlVersion: v1.0

inputs:
  mate1-ids-file:
    type: File
  mate2-ids-file:
    type: File
  prefix:
    type: File
  synapse_config:
    type: File
  specimenId:
    type: string
  platform_unit:
    type: string
    doc: "Comes from the original pipeline. it should probably be an annotation"

outputs:
  quants:
    type: File
    outputSource: run-bwa-mem/output

requirements:
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

steps:
  get-mate1-files:
    run: steps/out-to-array-tool.cwl
    in:
      datafile: mate1-ids-file
    out: [output-array]
  get-mate2-files:
    run: steps/out-to-array-tool.cwl
    in:
      datafile: mate2-ids-file
    out: [output-array]
  download-mate1-files:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
    scatter: synapseid
    in:
      synapseid: get-mate1-files/output-array
      synapse_config: synapse_config
    out: [filepath]
  download-mate2-files:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
    scatter: synapseid
    in:
      synapseid: get-mate2-files/output-array
      synapse_config: synapse_config
    out: [filepath]
  run-bwa-index:
    run: steps/bwa-index-tool.cwl
    in:
      sequences:
        source: prefix
    out:
       [output]
  make-read-group-header:
    run: steps/make-read-group-header.cwl
    in:
      specimenId: specimenId
      platform_unit: platform_unit
    out: [read_group_header]
  run-bwa-mem:
    run: steps/bwa-mem-tool.cwl
    in:
      input1:
        source: download-mate1-files/filepath
      input2:
        source: download-mate2-files/filepath
      prefix: run-bwa-index/output
      read_group_header:
        source: make-read-group-header/read_group_header
      output_name:
        source: specimenId
        valueFrom: $(self + '.sam')
    out:
       [output]
