CREATE FUNCTION [meta].[EntityTypeName]
(
	@EntityId int
)
RETURNS varchar(50)
AS
BEGIN
	RETURN (SELECT EntityTypeName 
	        FROM 
		   meta.EDWEntity e
	        INNER JOIN 
		   meta.EntityType t
	        ON e.EntityTypeId = t.EntityTypeId	
	        WHERE EntityId = @EntityId
	);
END