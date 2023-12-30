CREATE TABLE HOSPITAL.PHYSIO_BODYIMAGES_SAVE
(
  ID           INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999999999999999999999 CACHE 20 CYCLE ORDER KEEP) NOT NULL,
  BODYPART_ID  INTEGER                          NOT NULL,
  DESCRIPTION  NVARCHAR2(512),
  CREATEDBY    INTEGER,
  STATUS       INTEGER,
  IMAGEDATA    BLOB                             NOT NULL,
  EXT          NVARCHAR2(20)
);


ALTER TABLE HOSPITAL.PHYSIO_BODYIMAGES_SAVE ADD (
  CONSTRAINT PHYSIO_BODYIMAGES_SAVE_PK
  PRIMARY KEY
  (ID)
  ENABLE VALIDATE);
