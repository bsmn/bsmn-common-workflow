class: Workflow
label: bsmn-common-workflow
id: bsmn-common-workflow
cwlVersion: v1.0

inputs:
  synapse_config:
    type: File
  parentid:
    type: string
  file_to_store:
    type: File
  annotations_json_string:
    type: string

requirements:
  - class: SubworkflowFeatureRequirement

outputs:
  annotate-result:
    type: File
    outputSource: synapse-annotate/output
  store-result:
    type: File
    outputSource: synapse-store/stdout

steps:
  synapse-store:
    run: https://raw.githubusercontent.com/kdaily/synapse-client-cwl-tools/master/synapse-store-tool.cwl
    in:
      synapse_config: synapse_config
      parentid: parentid
      file_to_store: file_to_store
    out: [stdout]

  synapse-annotate:
    run: syn-annotate.cwl
    in:
      synapse_config: synapse_config
      file_to_store: file_to_store
      store_stdout: synapse-store/stdout
      annotations_json_string: annotations_json_string
    out:
      [output]
