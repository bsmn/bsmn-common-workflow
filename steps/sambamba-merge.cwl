#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0

doc: "Run sambamba merge tool."

s:author:
  - class: s:Person
    s:identifier: http://orcid.org/0000-0002-4475-8396
    s:email: mailto:tess.thyer@sagebionetworks.org
    s:name: 

s:contributor:
  - class: s:Person
    s:identifier: http://orcid.org/orcid.org/0000-0001-5729-7376
    s:email: mailto:kenneth.daily@sagebionetworks.org
    s:name: Kenneth Daily

$namespaces:
  s: https://schema.org/

$schemas:
 - https://schema.org/docs/schema_org_rdfa.html

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
          THREADS="$(inputs.threads ? '-t ' + inputs.threads : '')"

          set -x
          
          case $NUM_FILES in
            0)
              echo "Error: this script requires at least one input file."
              exit 1
              ;;
            1)
              cp $INPUT_PATHS $OUTPUT_NAME
              ;;
            *)
              sambamba merge $THREADS $OUTPUT_NAME $INPUT_PATHS
              ;;
          esac
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/sambamba:0.6.8--h682856c_1

baseCommand: ["sh", "merge.sh"]

inputs:
  threads:
    type: int?
    inputBinding:
      position: 1
      prefix: "--nthreads"
  output_name:
    type: string
    inputBinding:
      position: 2
      prefix: "--out"
  input_files:
    type: File[]
    inputBinding:
      prefix: "--inputs"
      position: 3

outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
