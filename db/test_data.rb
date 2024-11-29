# Create Reports for testing the check_report_matches functionality

# Constants
reporter_email = "test@example.com"
reported_twitch_id = "123456789"
reported_twitch_name = "pcalle2"
incident_occurred = "pcalle2"
incident_stream = "pcalle2"
incident_stream_twitch_id = "123"

# Report 1: Exact Match within Time Window
Report.create(
  reporter_email: reporter_email,
  reported_twitch_id: reported_twitch_id,
  incident_description: "Report about an issue",
  recommended_response: "Immediate action required",
  reported_twitch_name: reported_twitch_name,
  incident_occurred: incident_occurred,
  incident_stream_twitch_id: incident_stream_twitch_id,
  incident_stream: incident_stream,
  created_at: 1.hour.ago
)

# Report 2: Match with slightly different descriptions and responses
Report.create(
  reporter_email: reporter_email,
  reported_twitch_id: reported_twitch_id,
  incident_description: "Detailed report about an issue",
  recommended_response: "Immediate action needed",
  reported_twitch_name: reported_twitch_name,
  incident_occurred: incident_occurred,
  incident_stream_twitch_id: incident_stream_twitch_id,
  incident_stream: incident_stream,
  created_at: 1.hour.ago
)

# Report 3: Outside Time Window
Report.create(
  reporter_email: reporter_email,
  reported_twitch_id: reported_twitch_id,
  incident_description: "Old report about an unrelated issue",
  recommended_response: "Review later",
  reported_twitch_name: reported_twitch_name,
  incident_occurred: incident_occurred,
  incident_stream_twitch_id: incident_stream_twitch_id,
  incident_stream: incident_stream,
  created_at: 3.days.ago
)

# Report 4: No similarity in description or response
Report.create(
  reporter_email: reporter_email,
  reported_twitch_id: reported_twitch_id,
  incident_description: "Unrelated issue report",
  recommended_response: '',  # No recommended response
  reported_twitch_name: reported_twitch_name,
  incident_occurred: incident_occurred,
  incident_stream_twitch_id: incident_stream_twitch_id,
  incident_stream: incident_stream,
  created_at: 30.minutes.ago
)

# Report 5: Report with nil recommended_response matching another nil
Report.create(
  reporter_email: reporter_email,
  reported_twitch_id: reported_twitch_id,
  incident_description: "Issue report with no response recommended",
  recommended_response: "",
  reported_twitch_name: reported_twitch_name,
  incident_occurred: incident_occurred,
  incident_stream_twitch_id: incident_stream_twitch_id,
  incident_stream: incident_stream,
  created_at: 2.hours.ago
)
