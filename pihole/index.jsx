import { css, styled } from 'uebersicht';

export const command = 'curl -s http://pi.hole/admin/api.php?summary';

export const refreshFrequency = 60 * 1000 * 10;

export const className = css`
  right: 10px;
  width: 450px;
  top: 430px;
`;

const Container = styled('div')`
  background: rgba(0, 0, 0, 0.5);
  border-radius: 5px;
  color: #ffffff;
  font-family: 'HelveticaNeue-Light', 'Helvetica Neue Light', 'Helvetica Neue', Helvetica, 'Open Sans', sans-serif;
  padding: 10px;
  word-break: break-word;
`;

const Header = styled('h1')`
  align-items: center;
  color: #fff;
  display: flex;
  font-size: 3rem;
  font-weight: 700;
  justify-content: space-between;
  line-height: 1;
  letter-spacing: -0.04rem;
  margin: 0;
  img {
    height: 5rem;
  }
`;

const Ads = styled('span')`
  color: rgba(2, 192, 239, 1);
`;

const Blocked = styled('span')`
  color: rgba(221, 75, 57, 1);
`;

const PiHole = styled('span')`
  span {
    font-weight: 100;
  }
`;

const Stats = styled('div')`
  font-size: 1.25rem;
  margin-top: 1rem;
  padding: 0.5rem;
  span {
    font-weight: 700;
  }
`;

const TotalQueries = styled(Stats)`
  background: rgba(0, 166, 90, 0.5);
`;

const BlockedQueries = styled(Stats)`
  background: rgba(2, 192, 239, 0.5);
`;

const PercentBlocked = styled(Stats)`
  background: rgba(243, 156, 17, 0.5);
`;

const BlockedDomains = styled(Stats)`
  background: rgba(221, 75, 57, 0.5);
`;

const Warning = styled('span')`
  font-size: 1rem;
  color: #fff;
`;

export const updateState = (event, previousState) => {
  try {
    const data = JSON.parse(event.output);
    return {
      ...previousState,
      data
    };
  } catch (e) {
    return { ...previousState, warning: `Pi-hole is unavailable.` };
  }
};

export const render = ({ data, warning }) => {
  if (warning || !data) {
    return (
      <Container>
        <Warning>{warning}</Warning>
      </Container>
    );
  }
  return (
    <Container>
      <Header>
        <div>
          <Ads>{data.ads_blocked_today}</Ads> ads <Blocked>blocked</Blocked> by{' '}
          <PiHole>
            <span>Pi&#8209;</span>hole
          </PiHole>{' '}
          today.
        </div>
        <img src="pihole/images/pi-hole-logo.png" />
      </Header>
      <TotalQueries>
        Total Queries (<span>{data.clients_ever_seen}</span> clients): <span>{data.dns_queries_today}</span>
      </TotalQueries>
      <BlockedQueries>
        Queries Blocked: <span>{data.ads_blocked_today}</span>
      </BlockedQueries>
      <PercentBlocked>
        Percent Blocked: <span>{data.ads_percentage_today}%</span>
      </PercentBlocked>
      <BlockedDomains>
        Domains on Blocklist: <span>{data.domains_being_blocked}</span>
      </BlockedDomains>
    </Container>
  );
};
