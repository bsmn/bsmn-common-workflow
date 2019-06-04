#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: dailyk/dockstore-tool-bwa-mem:2.0
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
  Developed at Cincinnati Children’s Hospital Medical Center for the CWL consortium http://commonwl.org/ Original URL: https://github.com/common-workflow-language/workflows
  Usage:   bwa index [options] <in.fasta>

  Options: -a STR    BWT construction algorithm: bwtsw or is [auto]
           -p STR    prefix of the index [same as fasta name]
           -b INT    block size for the bwtsw algorithm (effective with -a bwtsw) [10000000]
           -6        index files named as <in.fasta>.64.* instead of <in.fasta>.*

  Warning: `-a bwtsw' does not work for short genomes, while `-a is' and
           `-a div' do not work not for long genomes.

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
