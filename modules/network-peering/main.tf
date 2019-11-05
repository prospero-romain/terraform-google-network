/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  # TODO: replace with regex("\\/([a-z][-a-z0-9]*[a-z0-9])$", var.local_network)[0] once we use terraform >= 0.12.7
  local_network_name = split("/", var.local_network)[length(split("/", var.local_network)) - 1]
  peer_network_name  = split("/", var.peer_network)[length(split("/", var.peer_network)) - 1]
}

resource "google_compute_network_peering" "local_network_peering" {
  name         = "${var.prefix}-${local.local_network_name}-${local.peer_network_name}"
  network      = var.local_network
  peer_network = var.peer_network
}

resource "google_compute_network_peering" "peer_network_peering" {
  name         = "${var.prefix}-${local.peer_network_name}-${local.local_network_name}"
  network      = var.peer_network
  peer_network = var.local_network

  depends_on = ["google_compute_network_peering.local_network_peering"]
}
