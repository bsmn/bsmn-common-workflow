#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
doc: "Developed at Cincinnati Children’s Hospital Medical Center for the CWL consortium http://commonwl.org/ Original URL: https://github.com/common-workflow-language/workflows"

requirements:
  - class: DockerRequirement
    dockerPull: dailyk/dockstore-tool-bwa-mem:2.0

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

s:author:
  - class: s:Person
    s:identifier: http://orcid.org/0000-0001-9102-5681
    s:email: mailto:Andrey.Kartashov@cchmc.org
    s:name: Andrey Kartashov

s:contributor:
  - class: s:Person
    s:identifier: http://orcid.org/orcid.org/0000-0001-5729-7376
    s:email: mailto:kenneth.daily@sagebionetworks.org
    s:name: Kenneth Daily

s:contributor:
  - class: s:Person
    s:identifier: http://orcid.org/orcid.org/0000-0002-6130-1021
    s:email: mailto:help@cancercollaboratory.org
    s:name: Denis Yuen

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
 - https://schema.org/docs/schema_org_rdfa.html
 - http://edamontology.org/EDAM_1.18.owl
