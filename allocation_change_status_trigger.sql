DELIMITER //

CREATE TRIGGER trg_UpdateStatus
BEFORE UPDATE ON allocation
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        IF NEW.status = b'0' THEN
            SET NEW.endDate = NOW();  -- Set endDate to current date when status changes to false
        ELSEIF NEW.status = b'1' THEN
            SET NEW.endDate = NULL;   -- Set endDate to NULL when status changes to true
        END IF;
    END IF;
END; //

DELIMITER ;