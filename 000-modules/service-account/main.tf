resource "google_service_account" "this" {
  account_id   = var.account_id
  display_name = var.display_name
  project      = var.project
}

resource "google_service_account_key" "this" {
  service_account_id = google_service_account.this.name
}

resource "google_project_iam_member" "this" {
  count = length(var.sa_role_binding)

  project = var.project
  role    = var.sa_role_binding[count.index]

  member = "serviceAccount:${google_service_account.this.email}"

  depends_on = [google_service_account.this]
}
