#!/usr/bin/env cwl-runner

class: Workflow
label: syn-annotate
id: syn-annotate
cwlVersion: v1.0

requirements:
  - class: SubworkflowFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
  synapse_config:
    type: File
  file_to_store:
    type: File
  annotations_json_string:
    type: string
  store_stdout:
    File

outputs:
  output:
    type: File
    outputSource: synapse-annotate/stdout

steps:
  synapse-annotate:
    run: https://raw.githubusercontent.com/kdaily/synapse-client-cwl-tools/kdaily-syn-set-annotations/synapse-set-annotations.cwl
    in:
      synapse_config: synapse_config
      synapse_id:
        valueFrom: $(inputs.file_to_store.path)
      annotations_json_string: annotations_json_string
    out:
      [stdout]
