#!/usr/bin/env cwl-runner

label: make-read-group-header
id: make-read-group-header
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python

requirements:
 - class: InlineJavascriptRequirement
 - class: DockerRequirement
   dockerPull: python:alpine
 - class: InitialWorkDirRequirement
   listing:
     - entryname: make-read-group-header.py
       entry: |
         #!/usr/bin/env python
         import json
         import sys
         specimenId = sys.argv[1]
         platform_unit = sys.argv[2]
         read_group_header_base = '@RG\\tID:{specimenId}.{platform_unit}\\tSM:{specimenId}\\tPL:illumina\\tLB:{specimenId}\\tPU:{platform_unit}'
         read_group_header = read_group_header_base.format(specimenId=specimenId, platform_unit=platform_unit)
         wr = open("read-group-header.txt", "w")
         wr.write(read_group_header)
         wr.close()
inputs:
  specimenId: string
  platform_unit: string
arguments:
  - valueFrom: make-read-group-header.py
  - valueFrom: $(inputs.specimenId)
  - valueFrom: $(inputs.platform_unit)

outputs:
  - id: read_group_header
    type: string
    outputBinding:
      glob: read-group-header.txt
      loadContents: true
      outputEval: $(self[0].contents)
