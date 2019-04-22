#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0

dct:contributor:
  "@id": "http://orcid.org/orcid.org/0000-0001-5729-7376"
  foaf:name: Kenneth Daily
  foaf:mbox: "mailto:kenneth.daily@sagebionetworks.org"

dct:contributor:
  "@id": "http://orcid.org/orcid.org/0000-0002-6130-1021"
  foaf:name: Denis Yuen
  foaf:mbox: "mailto:help@cancercollaboratory.org"

dct:creator:
  "@id": "http://orcid.org/0000-0001-9102-5681"
  foaf:name: "Andrey Kartashov"
  foaf:mbox: "mailto:Andrey.Kartashov@cchmc.org"

dct:description: "Developed at Cincinnati Children’s Hospital Medical Center for \
                  the CWL consortium http://commonwl.org/ \
                  Original URL: https://github.com/common-workflow-language/workflows"

requirements:
  - class: DockerRequirement
    dockerPull: kdaily/dockstore-tool-bwa-mem:2.0

inputs:
  prefix:
    type: File
    inputBinding:
      position: 2
    secondaryFiles:
      - ".amb"
      - ".ann"
      - ".bwt"
      - ".pac"
      - ".sa"

  input1:
    type: File[]
    inputBinding:
      position: 5

  input2:
    type: File[]
    inputBinding:
      position: 6

  output_name:
    type: string

  threads:
    type: int?
    inputBinding:
      position: 1
      prefix: "-t"

  read_group_header:
    type: string?
    inputBinding:
      position: 3
      prefix: "-R"

outputs:
  sam_file:
    type: File
    outputBinding:
      glob: $(inputs.output_name)

stdout: $(inputs.output_name)

baseCommand: ["bwa", "mem"]
