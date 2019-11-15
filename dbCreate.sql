CREATE TABLE junction (
    CounterReadingID integer,
    CounterID_ASTA integer,
    SequenceNumber integer,
    StartTime TIMESTAMP,
    EndTime TIMESTAMP,
    Visits INTEGER,
    ASTA_CountersCounterID_PAVE INTEGER,
    ASTA_CountersName_ASTA VARCHAR(400),
    ASTA_CountersInstallationDate TIMESTAMP,
    ASTA_CountersNationalParkCode INTEGER,
    ASTA_CountersMunicipality INTEGER,
    ASTA_CountersRegionalUnit INTEGER,
    ASTA_CountersRegionalEntity INTEGER,
    PAVE_CountersGlobalid VARCHAR(400),
    PAVE_CountersName VARCHAR(400),
    PAVE_CountersManager VARCHAR(400),
    PAVE_CountersAdditionalInfo VARCHAR(400),
    PAVE_CountersCoordinateNorth INTEGER,
    PAVE_CountersCoordinateEast INTEGER
);

SELECT ST_MakePoint(PAVE_CountersCoordinateNorth, PAVE_CountersCoordinateEast) as moro
FROM junction;
