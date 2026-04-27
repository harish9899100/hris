ActiveAdmin.register Organization do
  permit_params :name, :slug

  index do
    selectable_column
    id_column
    column :name
    column :slug
    column :created_at
    actions
  end

  filter :name
  filter :slug
  filter :created_at

  form do |f|
    f.inputs "Organization Details" do
      f.input :name
      f.input :slug
    end

    f.inputs "Leave Settings" do
      f.input :annual_leave_quota,
        label: "Annual Leave",
        input_html: { value: f.object.settings["annual_leave_quota"] || 21 }

      f.input :sick_leave_quota,
        label: "Sick Leave",
        input_html: { value: f.object.settings["sick_leave_quota"] || 10 }

      f.input :casual_leave_quota,
        label: "Casual Leave",
        input_html: { value: f.object.settings["casual_leave_quota"] || 7 }
    end

    f.inputs "Attendance Settings" do
      f.input :work_start_time,
        label: "Work Start Time",
        input_html: { value: f.object.settings["work_start_time"] || "10:00" }

      f.input :late_threshold_minutes,
        label: "Late Threshold (minutes)",
        input_html: { value: f.object.settings["late_threshold_minutes"] || 15 }

      li do
        label "Attendance Based Deduction"
        check_box_tag(
          "organization[attendance_based_deduction]",
          "1",
          f.object.settings["attendance_based_deduction"]
        )
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :slug

      row "Annual Leave" do |org|
        org.settings["annual_leave_quota"] || 21
      end

      row "Sick Leave" do |org|
        org.settings["sick_leave_quota"] || 10
      end

      row "Casual Leave" do |org|
        org.settings["casual_leave_quota"] || 7
      end

      row "Working Days" do |org|
        org.settings["working_days"]&.join(", ")
      end

      row "Work Start Time" do |org|
        org.settings["work_start_time"] || "10:00"
      end

      row "Late Threshold" do |org|
        "#{org.settings["late_threshold_minutes"] || 15} minutes"
      end

      row "Attendance Based Deduction" do |org|
        org.settings["attendance_based_deduction"] ? "Enabled" : "Disabled"
      end

      row :created_at
      row :updated_at
    end
  end

  controller do
    def update
      org = Organization.find(params[:id])
      org.settings ||= {}

      org.settings["annual_leave_quota"] =
        params[:organization][:annual_leave_quota].to_i

      org.settings["sick_leave_quota"] =
        params[:organization][:sick_leave_quota].to_i

      org.settings["casual_leave_quota"] =
        params[:organization][:casual_leave_quota].to_i

      org.settings["work_start_time"] =
        params[:organization][:work_start_time]

      org.settings["late_threshold_minutes"] =
        params[:organization][:late_threshold_minutes].to_i

      org.settings["attendance_based_deduction"] =
        params[:organization][:attendance_based_deduction] == "1"

      org.update!(
        name: params[:organization][:name],
        slug: params[:organization][:slug],
        settings: org.settings
      )

      redirect_to admin_organization_path(org),
        notice: "Organization updated successfully."
    end
  end
end