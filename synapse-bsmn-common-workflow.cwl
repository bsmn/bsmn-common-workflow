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

outputs:
  sam_file:
    type: File
    outputSource: run-bwa-mem/sam_file

requirements:
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

steps:
  get-mate1-files:
    doc: "Get the first mate file IDs from the query to an array"
    run: steps/out-to-array-tool.cwl
    in:
      datafile: mate1-ids-file
    out: [output-array]

  get-mate2-files:
    doc: "Get the second mate file IDs from the query to an array"
    run: steps/out-to-array-tool.cwl
    in:
      datafile: mate2-ids-file
    out: [output-array]

  download-mate1-files:
    doc: "Download all of the first mate files from Synapse"
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
    scatter: synapseid
    in:
      synapseid: get-mate1-files/output-array
      synapse_config: synapse_config
    out: [filepath]

  download-mate2-files:
    doc: "Download all of the second mate files from Synapse"
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
    scatter: synapseid
    in:
      synapseid: get-mate2-files/output-array
      synapse_config: synapse_config
    out: [filepath]

  get-platform-unit:
    doc: "Get the platform unit ({FLOWCELL_BARCODE}.{LANE}.{SAMPLE_BARCODE}) from the mate 1 fastq file."
    run: steps/get-platform-unit.cwl
    in:
      fastq_files: download-mate1-files/filepath
    out: [platform_unit]

  run-bwa-index:
    doc: "Create BWA index from the genome fasta file"
    run: steps/bwa-index-tool.cwl
    in:
      sequences:
        source: prefix
    out:
       [output]

  make-read-group-header:
    doc: "Use the specimen ID and platform unit to construct read group header for bwa mem."
    run: steps/make-read-group-header.cwl
    in:
      specimenId: specimenId
      platform_unit: get-platform-unit/platform_unit
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
       [sam_file]
