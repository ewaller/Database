SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `userpod` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `userpod` ;

-- -----------------------------------------------------
-- Table `userpod`.`accounts`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `userpod`.`accounts` (
  `account-id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `account-name` VARCHAR(128) NOT NULL ,
  PRIMARY KEY (`account-id`) ,
  UNIQUE INDEX `ACCOUNT-IDX` (`account-name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `userpod`.`products`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `userpod`.`products` (
  `product-id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `account-id` BIGINT UNSIGNED NOT NULL ,
  `make` VARCHAR(64) NOT NULL ,
  `model` VARCHAR(64) NOT NULL ,
  `serial-number` VARCHAR(64) NULL ,
  `service-tag` VARCHAR(32) NULL ,
  `type` VARCHAR(32) NULL ,
  `purchase-date` DATE NOT NULL ,
  `new` TINYINT(1) NULL DEFAULT 1 ,
  PRIMARY KEY (`product-id`) ,
  INDEX `PRODUCT-ACCOUNT-FK` (`account-id` ASC) ,
  INDEX `MAKE-MODEL-KY` (`account-id` ASC, `make` ASC, `model` ASC) ,
  CONSTRAINT `PRODUCT-ACCOUNT-FK`
    FOREIGN KEY (`account-id` )
    REFERENCES `userpod`.`accounts` (`account-id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `userpod`.`warrenties`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `userpod`.`warrenties` (
  `warrenty-id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `account-id` BIGINT UNSIGNED NOT NULL ,
  `start-date` DATE NOT NULL ,
  `expiration-date` DATE NOT NULL ,
  `company-name` VARCHAR(32) NOT NULL ,
  `company-url` VARCHAR(128) NOT NULL ,
  `login` VARCHAR(128) NULL ,
  `password` VARCHAR(32) NULL ,
  `service-telephone` VARCHAR(10) NOT NULL ,
  PRIMARY KEY (`warrenty-id`) ,
  INDEX `ACCOUNT-WARRENTY-FK` (`account-id` ASC) ,
  INDEX `COMPANY-NAME-IDX` (`company-name` ASC) ,
  CONSTRAINT `ACCOUNT-WARRENTY-FK`
    FOREIGN KEY (`account-id` )
    REFERENCES `userpod`.`accounts` (`account-id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `userpod`.`members`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `userpod`.`members` (
  `member-id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `account-id` BIGINT UNSIGNED NOT NULL ,
  `member-name` VARCHAR(128) NOT NULL ,
  `email` VARCHAR(128) NULL ,
  `password` VARCHAR(32) NOT NULL ,
  PRIMARY KEY (`member-id`) ,
  UNIQUE INDEX `ACCOUNT-IDX` (`member-name` ASC) ,
  INDEX `MEMBER-ACCOUNT-FK_idx` (`account-id` ASC) ,
  CONSTRAINT `MEMBER-ACCOUNT-FK`
    FOREIGN KEY (`account-id` )
    REFERENCES `userpod`.`accounts` (`account-id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `userpod`.`service-logs`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `userpod`.`service-logs` (
  `service-log-id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `product-id` BIGINT UNSIGNED NOT NULL ,
  `warrenty-id` BIGINT UNSIGNED NOT NULL ,
  `member-name` VARCHAR(128) NOT NULL ,
  `service-date` TIMESTAMP NOT NULL ,
  `service-type` VARCHAR(32) NULL ,
  `contact` VARCHAR(64) NULL ,
  `notes` VARCHAR(1024) NULL ,
  `column` VARCHAR(64) NULL ,
  PRIMARY KEY (`service-log-id`) ,
  INDEX `SERVICE_DATE-IDX` (`service-date` ASC) ,
  INDEX `PRODUCT-SERVICE-FK` (`product-id` ASC) ,
  INDEX `WARRENTY-SERVICE-FK_idx` (`warrenty-id` ASC) ,
  INDEX `MEMBER-SERVICE-FK_idx` (`member-name` ASC) ,
  CONSTRAINT `PRODUCT-SERVICE-FK`
    FOREIGN KEY (`product-id` )
    REFERENCES `userpod`.`products` (`product-id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `WARRENTY-SERVICE-FK`
    FOREIGN KEY (`warrenty-id` )
    REFERENCES `userpod`.`warrenties` (`warrenty-id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `MEMBER-SERVICE-FK`
    FOREIGN KEY (`member-name` )
    REFERENCES `userpod`.`members` (`member-name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `userpod`.`photographs`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `userpod`.`photographs` (
  `photograph-id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `photograph` BLOB NOT NULL ,
  PRIMARY KEY (`photograph-id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `userpod`.`product-photo-links`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `userpod`.`product-photo-links` (
  `product-id` BIGINT UNSIGNED NOT NULL ,
  `photograph-id` BIGINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`product-id`, `photograph-id`) ,
  INDEX `PRODUCT-PHOTO-FK` (`product-id` ASC) ,
  INDEX `PHOTO-PRODUCT-FK` (`photograph-id` ASC) ,
  CONSTRAINT `PRODUCT-PHOTO-FK`
    FOREIGN KEY (`product-id` )
    REFERENCES `userpod`.`products` (`product-id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `PHOTO-PRODUCT-FK`
    FOREIGN KEY (`photograph-id` )
    REFERENCES `userpod`.`photographs` (`photograph-id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `userpod`.`product-warrenty-links`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `userpod`.`product-warrenty-links` (
  `product-id` BIGINT UNSIGNED NOT NULL ,
  `warrenty-id` BIGINT UNSIGNED NOT NULL ,
  PRIMARY KEY (`product-id`, `warrenty-id`) ,
  INDEX `PRODUCT-WARRENTY-FK` (`product-id` ASC) ,
  INDEX `WARRENTY-PRODUCT-FK` (`warrenty-id` ASC) ,
  CONSTRAINT `PRODUCT-WARRENTY-FK`
    FOREIGN KEY (`product-id` )
    REFERENCES `userpod`.`products` (`product-id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `WARRENTY-PRODUCT-FK`
    FOREIGN KEY (`warrenty-id` )
    REFERENCES `userpod`.`warrenties` (`warrenty-id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
