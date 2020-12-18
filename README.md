# Jira

This package models Jira data from [Fivetran's connector](https://fivetran.com/docs/applications/jira). It uses data in the format described by [this ERD](https://docs.google.com/presentation/d/1UPq2CWnqQpbjLxkTrcWvAekaZ0o0OdzXODTVmUXeGvs/edit#slide=id.g5f1e6b049a_8_0). 

> Note: This schema applies to Jira connections set up or fully re-synced after September 10, 2020.

This package enables you to better understand the workload, performance, and velocity of work done by your team using Jira issues. It achieves this by:
- Creating a daily issue history table to enable the quick creation of agile reports, such as burndown charts, along any issue field
- Enriching the core issue table with relevant data regarding its workflow and current state
- Aggregating bandwidth and issue velocity metrics along projects and users

> The Jira dbt package is compatible with BigQuery, Redshift, and Snowflake destinations.

## Models - transformation package version

This package contains transformation models, designed to work simultaneously with our [Jira source package](https://github.com/fivetran/dbt_jira_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below. Intermediate models are used to create these output models.

| **model**                | **description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `jira__daily_issue_field_history`             | Each record represents a day in which an issue remained open, complete with the issue's sprint, its status, and the values of any fields specified by the `issue_field_history_columns` variable. |
| `jira__issue_enhanced`            | Each record represents a Jira issue, enriched with data about its current assignee, reporter, sprint, epic, project, resolution, issue type, priority, and status. Also includes metrics reflecting assignments, sprint rollovers, and re-openings of the issue. Note: all epics are considered `issues` in Jira, and are therefore included in this model (where `issue_type='epic'`). |
| `jira__project`            | Each record represents a project, enriched with data about the users involved, how many issues have been opened or closed, the velocity of work, and the breadth of the project (ie its components and epics). |
| `jira__user`            | Each record represents a user, enriched with metrics regarding their open issues, completed issues, the projects they work on, and the velocity of their work. |

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration
By default, this package looks for your Jira data in the `jira` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Jira data is, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    jira_database: your_database_name
    jira_schema: your_schema_name
```

### Daily Issue Field History Columns
The `jira__daily_issue_field_history` model generates historical data for the columns specified by the `issue_field_history_columns` variable. By default, the only columns tracked are `status` and `sprint`, but all fields found in the Jira `FIELD` table can be included in this model.

If you would like to change these columns, add the following configuration to your dbt_project.yml file. Then, after adding the columns to your `dbt_project.yml` file, run the `dbt run --full-refresh` command to fully refresh any existing models.

```yml
# dbt_project.yml

...
config-version: 2

vars:
  jira:
    issue_field_history_columns: ['the', 'list', 'of', 'field', 'names'] # case-insensitive
```

> Note: `sprint` and `status` will always be tracked, as they are necessary for creating common agile reports. 

## Contributions
Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions or feedback, or need help? Book a time during our office hours [here](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or shoot us an email at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate dbt transformations with Fivetran [here](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
