<?php

namespace NK\Conversion;

/**
 * A class to convert data obtained by conversion() procedure 
 * into another representation
 */
abstract class ConversionDataConverter {

    /**
     * Converts the result of conversion procedure to Google Charts JSON table
     * 
     * @param \PDOStatement $statement
     * Pass successfully executed statement from conversion procedure
     * 
     * @return string A JSON string that contains Google Charts datatable.
     */
    public static function toJSON(\PDOStatement $statement) {
        $table = array();

        $table['cols'] = array(
            array('label' => 'Date', 'type' => 'date'),
            array('label' => 'Conversion', 'type' => 'number')
        );

        $rows = array();

        while ($row = $statement->fetch()) {
            $temp = array();
            $temp[] = array('v' => \Google\Chart\DataPreparator::stringToDateTime($row['date']));
            $temp[] = array('v' => $row['conversion']);
            $rows[] = array('c' => $temp);
        }

        $table['rows'] = $rows;

        //Encode table array
        $jsonTable = json_encode($table, JSON_PRETTY_PRINT);

        return $jsonTable;
    }

}
