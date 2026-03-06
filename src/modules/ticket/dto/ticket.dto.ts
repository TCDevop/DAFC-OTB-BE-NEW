import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsNotEmpty, IsOptional, MaxLength } from 'class-validator';

export class CreateTicketDto {
  @ApiProperty({ description: 'Budget ID' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  budgetId: string;

  @ApiProperty({ description: 'Season Group ID' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  seasonGroupId: string;

  @ApiProperty({ description: 'Season ID' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  seasonId: string;

  @ApiPropertyOptional({ description: 'Force creation despite warnings' })
  @IsOptional()
  force?: boolean;
}

export class ValidateTicketDto {
  @ApiProperty({ description: 'Budget ID' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  budgetId: string;

  @ApiPropertyOptional({ description: 'Season Group ID' })
  @IsString()
  @IsOptional()
  @MaxLength(255)
  seasonGroupId?: string;

  @ApiPropertyOptional({ description: 'Season ID' })
  @IsString()
  @IsOptional()
  @MaxLength(255)
  seasonId?: string;
}
