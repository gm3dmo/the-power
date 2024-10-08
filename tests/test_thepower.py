# Run this unit test by running:
#
#   python3 -m unittest discover -s tests -p 'test_*.py'
#
# from the root directory of the-power repository.

import unittest
import json
from thepower import ghe2json

class TestGhe2Json(unittest.TestCase):
    maxDiff = None

    # unit test for single-node instance information
    def test_ghe2json(self):
        input_text = """
        @kyanny
        , Your requested GHES 3.10.3 single-node resources in  australiaeast on azure (named: gheboot-kyanny-1716187058841) true are ready!
        This is a(n) SINGLE-NODE deployment of GHES
        Access the UI at:
          http://kyanny-mclq08.ghe-test.com
        Access the instance via SSH at:
          ssh://admin@gheboot-all-kyanny-0-mclq08.ghe-test.com:122
        The instances in this deployment are:
          gheboot-all-kyanny-0-mclq08.ghe-test.com
        You can get the Management Console and 'ghe-admin' user's password by running:
        ssh -p122 admin@gheboot-all-kyanny-0-mclq08.ghe-test.com -- cat /data/user/common/gheboot-password
        This Server will automatically be terminated on 2024-05-22T06:38:39Z
        """
        
        expected_output = {
            'hostname': 'kyanny-mclq08.ghe-test.com',
            'password_recovery': 'ssh -p122 admin@gheboot-all-kyanny-0-mclq08.ghe-test.com -- cat /data/user/common/gheboot-password',
            'ghes_version': '3.10.3',
            'termination_date': '2024-05-22T06:38:39Z',
            'token': '',
            'mgmt_password': 'unknown',
            'admin_password': 'unknown',
            'ip_addresses': [None, None],
            'ip_primary': None,
            'ip_replica': None,
            'admin_user': 'ghe-admin',
            'token_generate_url': f"https://kyanny-mclq08.ghe-test.com/settings/tokens/new"
        }
        
        result =json.loads(ghe2json(input_text, ssh=False))
        self.assertEqual(result, expected_output)

    # unit test for high availability instances information
    def test_ghe2json_ha(self):
        input_text = """
@gm3dmo
, Clustering is not configured on this host.
Too few arguments.
Your GHE 3.10.15 HA Cluster environment is ready!
IP address instances: 54.241.77.70, 52.53.149.20
Access the cluster:
  Web Node: https://gm3dmo-0f114c2029750cc46.ghe-test.com (Log in as 'ghe-admin')
  Primary Node: ssh://admin@gm3dmo-0f114c2029750cc46.ghe-test.com:122
You can get the Management Console and 'ghe-admin' user's password by running:
  ssh -p122 admin@gm3dmo-0f114c2029750cc46.ghe-test.com -- cat /data/user/common/qaboot-password
Cluster will automatically be terminated on 2024-08-19T10:56:44+00:00
        """
        
        expected_output = {
            'hostname': 'gm3dmo-0f114c2029750cc46.ghe-test.com',
            'password_recovery': 'ssh -p122 admin@gm3dmo-0f114c2029750cc46.ghe-test.com -- cat /data/user/common/qaboot-password',
            'ghes_version': '3.10.15',
            'termination_date': '2024-08-19T10:56:44+00:00',
            'token': '',
            'mgmt_password': 'unknown',
            'admin_password': 'unknown',
            'ip_addresses': ['none', '54.241.77.70', '52.53.149.20'],
            'ip_primary': '54.241.77.70',
            'ip_replica': '52.53.149.20',
            'admin_user': 'ghe-admin',
            'token_generate_url': f"https://gm3dmo-0f114c2029750cc46.ghe-test.com/settings/tokens/new"
        }
        
        result =json.loads(ghe2json(input_text, ssh=False))
        self.assertEqual(result, expected_output)

    # unit test for single-node instance information with backup-utils enabled
    def test_ghe2json_backup_utils(self):
        input_text = """
@kyanny
, Your requested GHES 3.14.0 single-node resources in  australiaeast on azure (named: gheboot-kyanny-1726216807714) true are ready!
This is a(n) SINGLE-NODE deployment of GHES
Access the UI at:
  http://kyanny-i3shce.ghe-test.net
Access the instance via SSH at:
  ssh://admin@gheboot-all-kyanny-0-i3shce.ghe-test.net:122
The instances in this deployment are:
  gheboot-all-kyanny-0-i3shce.ghe-test.net
You can get the Management Console and 'ghe-admin' user's password by running:
ssh -p122 admin@gheboot-all-kyanny-0-i3shce.ghe-test.net -- cat /data/user/common/gheboot-password
This Server will automatically be terminated on 2024-09-15T08:40:52Z
You've requested a Backup Utils server for this deployment.
Access the Backup Utils server via SSH at:
  ssh://ghe-admin@backups-kyanny-i3shce.ghe-test.net:22
  *This server will be terminated along with the rest of the instances in this request.
        """
        
        expected_output = {
            'hostname': 'kyanny-i3shce.ghe-test.net',
            'password_recovery': 'ssh -p122 admin@gheboot-all-kyanny-0-i3shce.ghe-test.net -- cat /data/user/common/gheboot-password',
            'ghes_version': '3.14.0',
            'termination_date': '2024-09-15T08:40:52Z',
            'token': '',
            'mgmt_password': 'unknown',
            'admin_password': 'unknown',
            'ip_addresses': [None, None],
            'ip_primary': None,
            'ip_replica': None,
            'admin_user': 'ghe-admin',
            'token_generate_url': f"https://kyanny-i3shce.ghe-test.net/settings/tokens/new",
            'backup_utils': 'ssh://ghe-admin@backups-kyanny-i3shce.ghe-test.net:22'
        }
        
        result =json.loads(ghe2json(input_text, ssh=False))
        self.assertEqual(result, expected_output)


if __name__ == '__main__':
    unittest.main()
