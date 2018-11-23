gcp_project_id = attribute('gcp_project_id', description: 'The GCP project identifier.')
gcp_project_name = attribute('gcp_project_name', description: 'The GCP project name.')

control "projects" do
	describe google_project(project: gcp_project_id) do
		it { should exist }
		its('name') { should eq gcp_project_name }
         	its('lifecycle_state') { should eq "ACTIVE" }
		if defined?(project.labels)
			its('labels') { should include('owner') }
		end
	end
end

control "networks" do
	# Network
	networks = google_compute_networks(project: gcp_project_id)
	describe networks do
		it { should exist }
		its('count') { should be 1 }
		its('network_names') { should_not eq 'default' }
	end
	# Subnetwork
	networks.network_names.each do |network_name|
		describe google_compute_network(project: gcp_project_id, name: network_name) do
		its ('subnetworks.count') { should be 2 }
		its ('auto_create_subnetworks'){ should be false }
		end
	end
end
