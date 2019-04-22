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

dct:description: "Developed at Cincinnati Children’s Hospital Medical Center for the CWL consortium http://commonwl.org/ Original URL: https://github.com/common-workflow-language/workflows"

requirements:
  - class: DockerRequirement
    dockerPull: dockstore-tool-bwa-mem:2.0
  - class: InitialWorkDirRequirement
    listing: [ $(inputs.sequences) ]

inputs:
  algorithm:
    type: string?
    inputBinding:
      prefix: -a
    doc: |
      BWT construction algorithm: bwtsw or is (Default: auto)
  sequences:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      position: 4
  block_size:
    type: int?
    inputBinding:
      prefix: -b
    doc: |
      Block size for the bwtsw algorithm (effective with -a bwtsw) (Default: 10000000)

outputs:
  output:
    type: File
    secondaryFiles:
      - ".amb"
      - ".ann"
      - ".bwt"
      - ".pac"
      - ".sa"
    outputBinding:
      glob: $(inputs.sequences.basename)

baseCommand: ["bwa", "index"]

doc: |
  Usage:   bwa index [options] <in.fasta>

  Options: -a STR    BWT construction algorithm: bwtsw or is [auto]
           -p STR    prefix of the index [same as fasta name]
           -b INT    block size for the bwtsw algorithm (effective with -a bwtsw) [10000000]
           -6        index files named as <in.fasta>.64.* instead of <in.fasta>.*

  Warning: `-a bwtsw' does not work for short genomes, while `-a is' and
           `-a div' do not work not for long genomes.
