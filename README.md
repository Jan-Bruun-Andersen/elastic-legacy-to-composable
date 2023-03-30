# elastic-legacy-to-composable
A small Bash-script, a jq-script, and Perl-script to do a basic conversion from
Elasticsearch legacy templates to composable templates.

As an example I have include a [legacy template from Elastic 7.17](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/indices-templates-v1.html) that can be converted like this:
```
$ ./convert2composable.sh legacy_template_1.json 
Converting legacy_template_1.json                   => legacy_template_1.json.new
Processed 1 files.
If you are satified with the new files, use the command

  rename ".json.new" ".json" *.json.new

to replace the old JSON files with the new.
```
