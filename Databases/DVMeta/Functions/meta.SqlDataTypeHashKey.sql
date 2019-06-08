CREATE FUNCTION [meta].[SqlDataTypeHashKey] ()
RETURNS VARCHAR(50)
AS
BEGIN
  RETURN
    CASE (SELECT [Value] FROM meta.[Configuration] WHERE Id = 'HashAlgorithm')
      WHEN 'MD5' THEN 'char(32)'
	  WHEN 'SHA' THEN 'char(40)'
	  WHEN 'SHA1' THEN 'char(40)'
	  WHEN 'SHA2_256' THEN 'char(64)'
	  WHEN 'SHA2_512' THEN 'char(128)'
	  ELSE 'Hash algorithm not supported.'
  END;
END
