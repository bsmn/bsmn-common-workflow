class: Workflow
label: bsmn-common-workflow
id: bsmn-common-workflow
cwlVersion: v1.0

inputs:
  prefix_id:
    type: string
  synapse_config:
    type: File
  id_query:
    type: string
  parentid:
    type: string

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

outputs:
  sam_file:
    type: File[]
    outputSource: run-alignment-by-specimen-id/output_file
  store-result:
    type: File[]
    outputSource: synapse-store-alignment-output/store-result
  annotate-result:
    type: File[]
    outputSource: synapse-store-alignment-output/annotate-result

steps:
    get-sample-file-table:
      doc: "Query a Synapse file view to get list of files and their annotations."
      run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-query-tool.cwl
      in:
        synapse_config: synapse_config
        query: id_query
      out: [query_result]

    get-samples-from-file-table:
      doc: "Split the table into three arrays of specimen IDs, mate 1 files, and mate 2 files."
      run: steps/breakdownfile-tool.cwl
      in:
         fileName: get-sample-file-table/query_result
      out: [specimenIds, mate1files, mate2files]

    get-genome-prefix:
      doc: "Get the genome prefix file from Synapse."
      run:  https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
      in:
        synapseid: prefix_id
        synapse_config: synapse_config
      out: [filepath]

    run-alignment-by-specimen-id:
      doc: "Bulk of the workflow happens here, translated from original BSMN pipeline specification."
      run: synapse-bsmn-common-workflow.cwl
      scatter: [specimenId, mate1-ids-file, mate2-ids-file]
      scatterMethod: dotproduct
      in:
        specimenId: get-samples-from-file-table/specimenIds
        mate1-ids-file: get-samples-from-file-table/mate1files
        mate2-ids-file: get-samples-from-file-table/mate2files
        prefix: get-genome-prefix/filepath
        synapse_config: synapse_config
      out: [output_file]

    synapse-store-alignment-output:
      doc: "Store the results of the alignment step to Synapse."
      run: steps/store-and-annotate.cwl
      scatter: [file_to_store]
      in:
        synapse_config: synapse_config
        parentid: parentid
        file_to_store: run-alignment-by-specimen-id/output_file
        annotations_json_string: {default: '{"specimenID": "test"}'}
      out: [store-result, annotate-result]
