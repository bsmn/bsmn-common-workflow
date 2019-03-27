class: Workflow
label: bsmn-common-workflow
id: bsmn-common-workflow
cwlVersion: v1.0

inputs:
  prefixid:
    type: File
  synapse_config:
    type: File
  idquery:
    type: string
  sample_query:
    type: string
  scripts:
    type: File[]
  parentid:
    type: string

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

outputs:
  out: run-alignment-by-specimen-id/quants

steps:
    get-prefix:
      run:  https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
      in:
        synapseid: prefixid
        synapse_config: synapse_config
      out: [filepath]
    get-fv:
       run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-query-tool.cwl
       in:
         synapse_config: synapse_config
         query: idquery
       out: [query_result]
    get-samples-from-fv:
      run: steps/breakdownfile-tool.cwl
      in:
         fileName: get-fv/query_result
      out: [specIds,mate1files,mate2files]
    run-alignment-by-specimen-id:
      run: synapse-bsmn-common-workflow.cwl
      scatter: [specimenId,mate1-ids,mate2-ids]
      scatterMethod: dotproduct
      in:
        specimenId: get-samples-from-fv/specIds
        mate1-ids: get-samples-from-fv/mate1files
        mate2-ids: get-samples-from-fv/mate2files
        prefix: get-prefix/filepath
        synapse_config: synapse_config
      out: [quants]
