<?php

namespace NK\Conversion;

/**
 * An adapter for a client database
 */
class DatabaseAdapter {

    private $dbhandler;

    /**
     * Establish connection with the database
     * 
     * @param $host string Hostname, port, or another location
     * @param $database string Database name
     * @param $user DB Login username
     * @param $password DB Login password
     * 
     * @return void
     */
    public function __construct($host, $database, $user, $password) {

        //Connect to a MySQL database using driver invocation
        $dsn = "mysql:dbname=$database;host=$host";
        $this->dbhandler = new \PDO($dsn, $user, $password);
    }

    /**
     * Calculate client conversion in intervals
     * 
     * Call to a conversion procedure on the database, receive 
     * the result and return it as a statement
     * 
     * @param $interval_days integer 
     * Days per interval
     * 
     * @return \PDOStatement Statement with client conversion statistics
     */
    public function conversion($interval_days) {

        //Prepare the procedure call query
        $sql = 'CALL conversion(?)';
        $statement = $this->dbhandler->prepare($sql);
        $statement->bindParam(1, $interval_days, \PDO::PARAM_INT);

        $statement->execute();

        return $statement;
    }

}
