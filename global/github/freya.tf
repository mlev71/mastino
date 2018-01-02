resource "github_team" "freya" {
  name        = "freya"
  description = "The Freya Team"
  privacy     = "secret"
}

resource "github_team_membership" "freya_membership_mfenner" {
  team_id  = "${github_team.freya.id}"
  username = "mfenner"
  role     = "maintainer"
}

resource "github_team_membership" "freya_membership_kjgarza" {
  team_id  = "${github_team.freya.id}"
  username = "kjgarza"
  role     = "maintainer"
}

resource "github_team_membership" "freya_membership_pcruse" {
  team_id  = "${github_team.freya.id}"
  username = "pcruse"
  role     = "member"
}

resource "github_team_membership" "freya_membership_brittadreyer" {
  team_id  = "${github_team.freya.id}"
  username = "brittadreyer"
  role     = "member"
}
