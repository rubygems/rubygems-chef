import redis
from checks import AgentCheck, CheckException
import pg8000 as pg

class DelayedJobCheck(AgentCheck):

    def check(self, instance):
        host = instance.get('host', '')
        port = instance.get('port', '')
        user = instance.get('username', '')
        password = instance.get('password', '')
        tags = instance.get('tags', [])
        dbname = instance.get('dbname', None)

        db = self._get_connection(host, port, user, password, dbname)
        total = self._get_total(db)
        failed = self._get_failed(db)

        self.gauge("delayed_job.total", total)
        self.gauge("delayed_job.failed", failed)

    def _get_total(self, db):
        cursor = db.cursor()
        cursor.execute('SELECT COUNT(*) AS count FROM delayed_jobs;')
        result = cursor.fetchone()
        return int(result[0])

    def _get_failed(self, db):
        cursor = db.cursor()
        cursor.execute('SELECT COUNT(*) AS count FROM delayed_jobs WHERE failed_at IS NOT NULL;')
        result = cursor.fetchone()
        return int(result[0])

    def _get_connection(self, host, port, user, password, dbname):

        if host != "" and user != "":
            if host == 'localhost' and password == '':
                # Use ident method
                connection = pg.connect("user=%s dbname=%s" % (user, dbname))
            elif port != '':
                connection = pg.connect(host=host, port=port, user=user,
                    password=password, database=dbname, ssl=False)
            else:
                connection = pg.connect(host=host, user=user, password=password,
                    database=dbname, ssl=ssl)
        else:
            if not host:
                raise CheckException("Please specify a Postgres host to connect to.")
            elif not user:
                raise CheckException("Please specify a user to connect to Postgres as.")

        return connection
