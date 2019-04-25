#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0

dct:creator:
  "@id": "http://orcid.org/0000-0001-5729-7376"
  foaf:name: Kenneth Daily
  foaf:mbox: "mailto:kenneth.daily@sagebionetworks.org"

dct:description: "Run sambamba sort tool."

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/biocontainers/sambamba:0.6.8--h682856c_1

inputs:
  memory_limit:
    type: string?
    inputBinding:
      position: 2
      prefix: "--memory-limit"

  threads:
    type: int
    inputBinding:
      position: 3
      prefix: "--nthreads"

  output_name:
    type: string
    inputBinding:
      position: 4
      prefix: "--out"

  input_file:
    type: File
    inputBinding:
      position: 5

outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output_name)

stdout: $(inputs.output_name)

baseCommand: ["sambamba", "sort"]
