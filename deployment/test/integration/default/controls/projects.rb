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

