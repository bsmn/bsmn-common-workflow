#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0

doc: "Run sambamba sort tool."

s:author:
  - class: s:Person
    s:identifier: http://orcid.org/orcid.org/0000-0001-5729-7376
    s:email: mailto:kenneth.daily@sagebionetworks.org
    s:name: Kenneth Daily

$namespaces:
  s: https://schema.org/

$schemas:
 - https://schema.org/docs/schema_org_rdfa.html

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
  output_files:
    type:
      type: array
      items: File
    outputBinding:
      glob: $(inputs.output_name)

stdout: $(inputs.output_name)

baseCommand: ["sambamba", "sort"]
