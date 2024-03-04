import unittest
import db

#Given a Unique User Identifier whose role is "user", when get_user_role is called, it should return "user"
class Testdb(unittest.TestCase):
    def test_get_user_role(self):
        uuid = 'asdf'
        user_role = db.get_user_role(uuid)
        self.assertEqual(user_role[2], "user")

if __name__ == '__main__':
    unittest.main()