-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Flight_Operations_DB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Flight_Operations_DB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Flight_Operations_DB` DEFAULT CHARACTER SET utf8 ;
USE `Flight_Operations_DB` ;

-- -----------------------------------------------------
-- Table `Flight_Operations_DB`.`states`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Flight_Operations_DB`.`states` (
  `state_id` INT NOT NULL AUTO_INCREMENT,
  `state_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`state_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Flight_Operations_DB`.`cities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Flight_Operations_DB`.`cities` (
  `city_id` INT NOT NULL AUTO_INCREMENT,
  `city_name` VARCHAR(100) NOT NULL,
  `state_id` INT NOT NULL,
  PRIMARY KEY (`city_id`),
  INDEX `fk_cities_states_idx` (`state_id` ASC) VISIBLE,
  CONSTRAINT `fk_cities_states`
    FOREIGN KEY (`state_id`)
    REFERENCES `Flight_Operations_DB`.`states` (`state_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Flight_Operations_DB`.`airports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Flight_Operations_DB`.`airports` (
  `airport_code` VARCHAR(5) NOT NULL,
  `city_id` INT NOT NULL,
  PRIMARY KEY (`airport_code`),
  INDEX `fk_airports_cities1_idx` (`city_id` ASC) VISIBLE,
  CONSTRAINT `fk_airports_cities1`
    FOREIGN KEY (`city_id`)
    REFERENCES `Flight_Operations_DB`.`cities` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Flight_Operations_DB`.`carriers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Flight_Operations_DB`.`carriers` (
  `carrier_code` VARCHAR(10) NOT NULL,
  `carrier_name` VARCHAR(100) NULL,
  PRIMARY KEY (`carrier_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Flight_Operations_DB`.`calendar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Flight_Operations_DB`.`calendar` (
  `fl_date` DATE NOT NULL,
  `year` INT NOT NULL,
  `month` INT NOT NULL,
  `day_of_month` INT NOT NULL,
  `day_of_week` INT NOT NULL,
  PRIMARY KEY (`fl_date`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Flight_Operations_DB`.`flights`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Flight_Operations_DB`.`flights` (
  `flight_id` INT NOT NULL AUTO_INCREMENT,
  `flight_num` INT NOT NULL,
  `carrier_code` VARCHAR(10) NOT NULL,
  `fl_date` DATE NOT NULL,
  `origin_airport` VARCHAR(5) NOT NULL,
  `dest_airport` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`flight_id`),
  INDEX `fk_flights_carriers1_idx` (`carrier_code` ASC) VISIBLE,
  INDEX `fk_flights_calendar1_idx` (`fl_date` ASC) VISIBLE,
  INDEX `fk_flights_airports1_idx` (`origin_airport` ASC) VISIBLE,
  INDEX `fk_flights_airports2_idx` (`dest_airport` ASC) VISIBLE,
  CONSTRAINT `fk_flights_carriers1`
    FOREIGN KEY (`carrier_code`)
    REFERENCES `Flight_Operations_DB`.`carriers` (`carrier_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flights_calendar1`
    FOREIGN KEY (`fl_date`)
    REFERENCES `Flight_Operations_DB`.`calendar` (`fl_date`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flights_airports1`
    FOREIGN KEY (`origin_airport`)
    REFERENCES `Flight_Operations_DB`.`airports` (`airport_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flights_airports2`
    FOREIGN KEY (`dest_airport`)
    REFERENCES `Flight_Operations_DB`.`airports` (`airport_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Flight_Operations_DB`.`flight_timings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Flight_Operations_DB`.`flight_timings` (
  `crs_dep_time` INT NOT NULL,
  `dep_time` INT NULL,
  `crs_arr_time` INT NOT NULL,
  `arr_time` INT NULL,
  `dep_delay` FLOAT NULL,
  `arr_delay` FLOAT NULL,
  `flight_id` INT NOT NULL,
  PRIMARY KEY (`flight_id`),
  CONSTRAINT `fk_flight_timings_flights1`
    FOREIGN KEY (`flight_id`)
    REFERENCES `Flight_Operations_DB`.`flights` (`flight_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Flight_Operations_DB`.`flight_operations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Flight_Operations_DB`.`flight_operations` (
  `taxi_out` FLOAT NULL,
  `wheels_off` INT NULL,
  `wheels_on` INT NULL,
  `taxi_in` FLOAT NULL,
  `air_time` FLOAT NULL,
  `distance` FLOAT NOT NULL,
  `crs_elapsed` FLOAT NOT NULL,
  `actual_elapsed` FLOAT NULL,
  `diverted` TINYINT(0) NOT NULL,
  `flight_id` INT NOT NULL,
  PRIMARY KEY (`flight_id`),
  CONSTRAINT `fk_flight_operations_flights1`
    FOREIGN KEY (`flight_id`)
    REFERENCES `Flight_Operations_DB`.`flights` (`flight_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Flight_Operations_DB`.`delay_stats`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Flight_Operations_DB`.`delay_stats` (
  `carrier_delay` FLOAT NULL,
  `weather_delay` FLOAT NULL,
  `nas_delay` FLOAT NULL,
  `security_delay` FLOAT NULL,
  `late_aircraft` FLOAT NULL,
  `flight_id` INT NOT NULL,
  PRIMARY KEY (`flight_id`),
  CONSTRAINT `fk_delay_stats_flights1`
    FOREIGN KEY (`flight_id`)
    REFERENCES `Flight_Operations_DB`.`flights` (`flight_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Flight_Operations_DB`.`cancellations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Flight_Operations_DB`.`cancellations` (
  `is_cancelled` TINYINT(0) NOT NULL,
  `cancel_code` VARCHAR(5) NULL,
  `flight_id` INT NOT NULL,
  PRIMARY KEY (`flight_id`),
  CONSTRAINT `fk_cancellations_flights1`
    FOREIGN KEY (`flight_id`)
    REFERENCES `Flight_Operations_DB`.`flights` (`flight_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
