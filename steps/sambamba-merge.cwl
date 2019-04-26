#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0

dct:creator:
  "@id": "http://orcid.org/0000-0002-4475-8396"
  foaf:name: Tess Thyer
  foaf:mbox: "mailto:tess.thyer@sagebionetworks.org"

dct:description: "Run sambamba merge tool."

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: merge.sh
        entry: |-
          #!/usr/bin/env bash

          NUM_FILES=$(inputs.input_files.length)
          INPUT_PATHS="$(inputs.input_files.map(function(file) { return file.path }).join(' '))"
          OUTPUT_NAME=$(inputs.output_name)
          case $NUM_FILES in
            0)
              echo "Error: this script requires at least one input file."
              exit 1
              ;;
            1)
              cp $INPUT_PATHS $OUTPUT_NAME
              ;;
            *)
              sambamba merge $OUTPUT_NAME $INPUT_PATHS
              ;;
          esac
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/sambamba:0.6.8--h682856c_1 # TODO find way to define this once for use between workflows

baseCommand: ["sh", "merge.sh"]

inputs:
  threads:
    type: int?
    inputBinding:
      position: 1
      prefix: "-t"
  output_name:
    type: string
    inputBinding:
      position: 2
  input_files:
    type: File[]
    inputBinding:
      prefix: --inputs
      position: 3
outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
