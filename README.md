# lab-environment
A fully automated network lab environment designed to operate with fully integrated observability stack to observe environment and display/build automation skills. Scalable and redundant, ability to create, and destroy on-demand.
Summary: A fully automated network lab environment designed to operate with fully integrated observability stack to observe environment and display/build automation skills. Scalable and redundant, ability to create and destroy on-demand w/ persistent configuration and changes. 

Build Process: Utilizing industry standard open source IAC tools to automate build process. No click-ops involved. Workflow below. All instances will be running standard node-exporter and be scraped so that we have instance observability info as well as our network gNMI data.
1.	Packer: Automated creation of below images. Rebuild weekly to patch OS, pin application versions. Test new images in CI then promote to latest via tag. 
a.	Grafana instances: stateless behind ALB w/ shared sharded DB (dashboards and viewing)
b.	Alloy: cluster mode  (scrapes and collects metrics)
c.	Mimir instances: S3 backend w/ multiple ingesters  (metric storage) 
d.	Loki instances: S3 backend  (log collection)
e.	Custom gNMI collector (could run this as a process on a different box concurrently but for the sake of things we’ll run as separate instance for now)
f.	Netbox (device source of truth) 
g.	Netlab (lab environment built from Netbox) 
2.	Terraform: IAC creation of instances along with other resources such as ALBs, internal DNS records, buckets, etc. 
3.	Ansible: Runtime configuration. Store as role-based playbooks w/ set defaults
4.	Wrap it all in Gitlab CI to automate each step as pipeline. 
Python exposure: In order to develop python experience I’m going to create several python services. 
•	A gNMI collector to collect info from lab devices and expose /metrics endpoint.
•	A service discovery service to replace the static Prometheus targets and generate dynamic inventory for Prometheus 
•	Possibly automate dashboard generation with grafanalib library.
•	Post deployment test suite to hit ALB, check Allo target health, confirm metric and log ingestion. 
•	Script that converts Netbox API to netlab topology.yml.
