--ヴァレット・リチャージャー
--
--Script by mercury233
function c100336003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100336003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100336003)
	e1:SetCondition(c100336003.spcon)
	e1:SetCost(c100336003.spcost)
	e1:SetTarget(c100336003.sptg)
	e1:SetOperation(c100336003.spop)
	c:RegisterEffect(e1)
	--cannot be attacked
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100336003.atcon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
end
function c100336003.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsAttribute(ATTRIBUTE_DARK)
		and c:GetSummonLocation()==LOCATION_EXTRA and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c100336003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100336003.spcfilter,1,nil,tp)
end
function c100336003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c100336003.tgfilter(c,e,tp)
	return c100336003.spcfilter(c,tp) and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c100336003.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,c)
end
function c100336003.spfilter(c,e,tp,tc)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c100336003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c100336003.tgfilter,nil,e,tp)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 end
	local c=nil
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		c=g:Select(tp,1,1,nil):GetFirst()
	else
		c=g:GetFirst()
	end
	Duel.SetTargetCard(c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100336003.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100336003.spfilter,tp,LOCATION_GRAVE,0,1,1,tc,e,tp,tc)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c100336003.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c100336003.atcon(e)
	return Duel.IsExistingMatchingCard(c100336003.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
