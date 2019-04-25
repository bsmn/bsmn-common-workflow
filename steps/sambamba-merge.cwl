#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0

dct:creator:
  "@id": "http://orcid.org/0000-0002-4475-8396"
  foaf:name: Tess Thyer
  foaf:mbox: "mailto:tess.thyer@sagebionetworks.org"

dct:description: "Run sambamba merge tool."

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entryname: merge.sh
        entry: |-
          echo ">>>>> BEGIN BAM MERGE <<<<<"
          OUTPUT_NAME=$(inputs.output_name)
          if [[ $(inputs.input_files.length) == 1 ]]; then
              cp $(inputs.input_files[0].path) $OUTPUT_NAME
          else
              INPUT_PATHS = $(inputs.input_files.map(a => a.path).join(" "))
              sambamba merge $OUTPUT_NAME $INPUT_PATHS
          fi          
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/sambamba:0.6.8--h682856c_1 # TODO define this once for use between workflows

baseCommand: ["sh", "merge.sh"]

inputs:
#  threads:
#    type: int?
#    inputBinding:
#      position: 1
#      prefix: "-t"
  output_name:
    type: string
    inputBinding:
      position: 3
#  input_files:
#    type: File
#    inputBinding:
#      position: 2
  input_files:
    type: File[]
    inputBinding:
      prefix: --inputs
      position: 5
outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
