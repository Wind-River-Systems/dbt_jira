-- just grabs user attributes for issue assignees and reporters 
with issue as (

    select *
    from {{ var('issue') }}

),

-- user is a reserved keyword in AWS
jira_user as (

    select *
    from {{ var('user') }}
),

issue_user_join as (

    select
        issue.issue_id,
        issue.assignee_user_id,
        assignee.user_display_name as assignee_name,
        assignee.time_zone as assignee_timezone,
        assignee.email as assignee_email,

        -- note: reporter is the user who created the issue by default, 
        -- but this can be changed in-app (making it potentially different from `creator`, which i 
        -- excluded from this model, but am open to including! 
        issue.reporter_user_id,
        reporter.email as reporter_email,
        reporter.user_display_name as reporter_name,
        reporter.time_zone as reporter_timezone
        
        
    from issue
    left join jira_user as assignee on issue.assignee_user_id = assignee.user_id 
    left join jira_user as reporter on issue.reporter_user_id = reporter.user_id

    {{ dbt_utils.group_by(n=9) }}
)

select * from issue_user_join