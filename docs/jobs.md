# Jobs

Jobs can be registered from separate resources, but it is recommended to register them in the jobs resource itself, especially for simple jobs that don't require significant functionality.

### Registering Jobs

Internally, in the jobs resource:
`RegisterJob(id, data)`

From external resources:
`exports.jobs:Register(id, data)`

* ID is a unique string, and is what other scripts would use to identify the job.
* Data is a table for that contains the job's structured parameters. See below for the possible inputs.

### Job Structure

A job can be given parameters that allow it to use other systems, or be used directly in a system built around the job.

```Lua
{
	Name = "Job Name", -- What is displayed 
	Faction = "faction", -- The faction identifier.
}
```