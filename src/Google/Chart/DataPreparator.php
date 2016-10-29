<?php

namespace Google\Chart;

/**
 * Prepare your data for export to Google Chart
 */
abstract class DataPreparator {

    /**
     * Converts datetime to JavaScript Date object for further export
     * 
     * @param string $string
     * String that contains date and/or time
     * 
     * @return string A string with JS formatted Date object.
     */
    public static function stringToDateTime($string) {

        // your original DTO
        $date = new \DateTime($string);

        // your newly formatted JS Date;
        return $date->format('\D\a\t\e\(Y,') .
                ($date->format('m') - 1) .
                $date->format(',d,H,i,s\)');
    }

}
