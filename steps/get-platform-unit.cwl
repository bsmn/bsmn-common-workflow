#!/usr/bin/env cwl-runner

label: get-platform-unit
id: get-platform-unit
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python

requirements:
 - class: InlineJavascriptRequirement
 - class: DockerRequirement
   dockerPull: python:alpine
 - class: InitialWorkDirRequirement
   listing:
     - entryname: get-platform-unit.py
       entry: |
         #!/usr/bin/env python
         import json
         import sys
         filename = sys.argv[1]
         fastq_file = open(filename)
         header = fastq_file.readline().lstrip("@")
         first, second = header.split(" ")
         res = first.split(":")
         platform_unit = ":".join(res[:3])
         wr = open("platform_unit.txt", "w")
         wr.write(platform_unit)
         wr.close()
inputs:
 fastq_files: File
arguments:
  - valueFrom: get-platform-unit.py
  - valueFrom: $(inputs.fastq_files)

outputs:
  - id: platform_unit
    type: string
    outputBinding:
      glob: platform_unit.txt
      loadContents: true
      outputEval: $(self[0].contents)
