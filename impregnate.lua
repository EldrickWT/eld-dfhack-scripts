-- Impregnates a creature

local args = {...}

function impregnate ()

  local victim = dfhack.gui.getSelectedUnit()
  local genes

  if (victim == nil) then
    return
  end

  genes = victim.appearance.genes:new()

  if (victim.relations.pregnancy_timer > 0) then
    print('Already pregnant!')
    return
  end

  victim.relations.pregnancy_genes = genes;
  victim.relations.pregnancy_timer = 30;

  if (victim.relations.lover_id == 0) then
    victim.relations.pregnancy_caste = 0;
  else
    victim.relations.pregnancy_caste = 1;
  end

end

dfhack.with_suspend(impregnate)
